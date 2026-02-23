"""
Custom runserver command that starts mDNS advertisement.
Usage: python manage.py runserver_mdns [port]
"""
from django.core.management.commands.runserver import Command as RunserverCommand
from air_quality.mdns_service import start_mdns, stop_mdns


class Command(RunserverCommand):
    help = 'Starts Django development server with mDNS advertisement for air quality sensors'

    def add_arguments(self, parser):
        super().add_arguments(parser)

    def handle(self, *args, **options):
        # Extract port from addrport
        addrport = options.get('addrport', '8000')
        if ':' in addrport:
            port = int(addrport.split(':')[1])
        else:
            try:
                port = int(addrport)
            except ValueError:
                port = 8000
        
        # Start mDNS
        start_mdns(port=port)
        
        try:
            super().handle(*args, **options)
        finally:
            stop_mdns()
