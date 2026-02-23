"""
mDNS advertisement service for Onyx Air Quality.
Advertises as 'onyx-server.local' so sensors can discover the server.
"""
import socket
import threading
from zeroconf import ServiceInfo, Zeroconf


class MDNSService:
    def __init__(self, hostname="onyx-server", port=8000):
        self.hostname = hostname
        self.port = port
        self.zeroconf = None
        self.service_info = None
        self._thread = None
    
    def _get_local_ip(self):
        """Get the local IP address."""
        try:
            s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            s.connect(("8.8.8.8", 80))
            ip = s.getsockname()[0]
            s.close()
            return ip
        except Exception:
            return "127.0.0.1"
    
    def _run(self):
        """Run mDNS in a thread."""
        try:
            local_ip = self._get_local_ip()
            self.zeroconf = Zeroconf()
            
            self.service_info = ServiceInfo(
                "_http._tcp.local.",
                f"{self.hostname}._http._tcp.local.",
                addresses=[socket.inet_aton(local_ip)],
                port=self.port,
                properties={"path": "/air-quality/api/readings/"},
                server=f"{self.hostname}.local.",
            )
            
            self.zeroconf.register_service(self.service_info)
            print(f"mDNS: Advertising as {self.hostname}.local ({local_ip}:{self.port})")
        except Exception as e:
            print(f"mDNS: Failed to start - {e}")
    
    def start(self):
        """Start mDNS advertisement in background thread."""
        self._thread = threading.Thread(target=self._run, daemon=True)
        self._thread.start()
    
    def stop(self):
        """Stop mDNS advertisement."""
        if self.zeroconf and self.service_info:
            try:
                self.zeroconf.unregister_service(self.service_info)
                self.zeroconf.close()
                print("mDNS: Stopped")
            except Exception as e:
                print(f"mDNS: Error stopping - {e}")


# Global instance
_mdns_service = None


def start_mdns(port=8000):
    """Start the mDNS service."""
    global _mdns_service
    _mdns_service = MDNSService(hostname="onyx-server", port=port)
    _mdns_service.start()


def stop_mdns():
    """Stop the mDNS service."""
    global _mdns_service
    if _mdns_service:
        _mdns_service.stop()
