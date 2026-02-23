const API_BASE = '';
const REFRESH_INTERVAL = 5000;

const SENSOR_COLORS = {
  'SENSOR_01': '#e53935',  // Red
  'SENSOR_02': '#43a047',  // Green
  'SENSOR_03': '#1e88e5',  // Blue
  'SENSOR_04': '#212121',  // Black
  'SENSOR_05': '#8e24aa'   // Purple
};

function getSensorColor(sensorId) {
  return SENSOR_COLORS[sensorId] || '#666666';
}

let sensors = [];
let chart = null;
let editingSensorId = null;

async function fetchSensors() {
  try {
    const response = await fetch(`${API_BASE}/api/sensors`);
    if (!response.ok) throw new Error('Failed to fetch sensors');
    sensors = await response.json();
    renderSensorsTable();
    updateSensorFilters();
    updateConnectionStatus(true);
    document.getElementById('last-update').textContent = 
      `Last update: ${new Date().toLocaleTimeString()}`;
  } catch (error) {
    console.error('Error fetching sensors:', error);
    updateConnectionStatus(false);
  }
}

function renderSensorsTable() {
  const tbody = document.getElementById('sensors-body');
  
  if (sensors.length === 0) {
    tbody.innerHTML = '<tr><td colspan="6" class="no-data">No sensors connected yet</td></tr>';
    return;
  }
  
  tbody.innerHTML = sensors.map(sensor => {
    const lastSeen = new Date(sensor.last_seen + 'Z');
    const isStale = (Date.now() - lastSeen.getTime()) > 60000;
    
    return `
      <tr>
        <td>
          <div class="sensor-name">
            <span style="color: ${getSensorColor(sensor.id)}; font-weight: 600;">${escapeHtml(sensor.display_name)}</span>
            <button class="edit-btn" onclick="openEditModal('${sensor.id}', '${escapeHtml(sensor.display_name)}')">✏️</button>
          </div>
        </td>
        <td>
          <span class="pm-value pm1">${sensor.pm1 !== null ? sensor.pm1.toFixed(1) : '--'}</span>
          <span class="pm-unit">µg/m³</span>
        </td>
        <td>
          <span class="pm-value pm25">${sensor.pm25 !== null ? sensor.pm25.toFixed(1) : '--'}</span>
          <span class="pm-unit">µg/m³</span>
        </td>
        <td>
          <span class="pm-value pm10">${sensor.pm10 !== null ? sensor.pm10.toFixed(1) : '--'}</span>
          <span class="pm-unit">µg/m³</span>
        </td>
        <td class="last-seen ${isStale ? 'stale' : ''}">
          ${formatTimestamp(lastSeen)}
        </td>
        <td class="actions">
          <button class="btn-reset-wifi" onclick="resetSensorWifi('${sensor.id}')" ${sensor.ip_address ? '' : 'disabled'} title="${sensor.ip_address ? 'Reset WiFi on ' + sensor.ip_address : 'IP unknown'}">
            🔄 Reset WiFi
          </button>
        </td>
      </tr>
    `;
  }).join('');
}

function updateSensorFilters() {
  const container = document.getElementById('sensor-filters');
  const existingIds = Array.from(container.querySelectorAll('input')).map(i => i.value);
  
  sensors.forEach(sensor => {
    if (!existingIds.includes(sensor.id)) {
      const label = document.createElement('label');
      label.innerHTML = `<input type="checkbox" value="${sensor.id}" checked> ${escapeHtml(sensor.display_name)}`;
      label.querySelector('input').addEventListener('change', fetchAndRenderChart);
      container.appendChild(label);
    }
  });
}

async function fetchAndRenderChart() {
  const hours = document.getElementById('time-range').value;
  const showPm1 = document.getElementById('show-pm1').checked;
  const showPm25 = document.getElementById('show-pm25').checked;
  const showPm10 = document.getElementById('show-pm10').checked;
  
  const selectedSensors = Array.from(
    document.querySelectorAll('#sensor-filters input:checked')
  ).map(i => i.value);
  
  if (selectedSensors.length === 0) {
    if (chart) {
      chart.data.datasets = [];
      chart.update();
    }
    return;
  }
  
  try {
    const allReadings = [];
    for (const sensorId of selectedSensors) {
      const response = await fetch(`${API_BASE}/api/readings?hours=${hours}&sensor_id=${sensorId}`);
      if (response.ok) {
        const readings = await response.json();
        allReadings.push({ sensorId, readings });
      }
    }
    
    renderChart(allReadings, { showPm1, showPm25, showPm10 });
  } catch (error) {
    console.error('Error fetching readings:', error);
  }
}

function renderChart(allReadings, { showPm1, showPm25, showPm10 }) {
  const datasets = [];
  
  allReadings.forEach(({ sensorId, readings }) => {
    const sensor = sensors.find(s => s.id === sensorId);
    const sensorName = sensor ? sensor.display_name : sensorId;
    const baseColor = getSensorColor(sensorId);
    
    const data = readings.map(r => ({
      x: new Date(r.timestamp),
      pm1: r.pm1,
      pm25: r.pm25,
      pm10: r.pm10
    }));
    
    if (showPm1) {
      datasets.push({
        label: `${sensorName} - PM1.0`,
        data: data.map(d => ({ x: d.x, y: d.pm1 })),
        borderColor: baseColor,
        backgroundColor: baseColor + '1a',
        tension: 0.3,
        pointRadius: 1,
        borderWidth: 2,
        borderDash: []
      });
    }
    
    if (showPm25) {
      datasets.push({
        label: `${sensorName} - PM2.5`,
        data: data.map(d => ({ x: d.x, y: d.pm25 })),
        borderColor: baseColor,
        backgroundColor: baseColor + '1a',
        tension: 0.3,
        pointRadius: 1,
        borderWidth: 2,
        borderDash: [5, 5]
      });
    }
    
    if (showPm10) {
      datasets.push({
        label: `${sensorName} - PM10`,
        data: data.map(d => ({ x: d.x, y: d.pm10 })),
        borderColor: baseColor,
        backgroundColor: baseColor + '1a',
        tension: 0.3,
        pointRadius: 1,
        borderWidth: 2,
        borderDash: [2, 2]
      });
    }
  });
  
  if (!chart) {
    const ctx = document.getElementById('history-chart').getContext('2d');
    chart = new Chart(ctx, {
      type: 'line',
      data: { datasets },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        interaction: { intersect: false, mode: 'index' },
        scales: {
          x: {
            type: 'time',
            time: {
              displayFormats: {
                minute: 'HH:mm',
                hour: 'HH:mm',
                day: 'MMM d'
              }
            },
            title: { display: false }
          },
          y: {
            title: { display: true, text: 'µg/m³' },
            beginAtZero: true
          }
        },
        plugins: {
          legend: {
            position: 'top',
            labels: { boxWidth: 12, padding: 10, font: { size: 11 } }
          }
        }
      }
    });
  } else {
    chart.data.datasets = datasets;
    chart.update();
  }
}

function openEditModal(sensorId, currentName) {
  editingSensorId = sensorId;
  document.getElementById('edit-name').value = currentName;
  document.getElementById('edit-modal').classList.remove('hidden');
  document.getElementById('edit-name').focus();
}

function closeEditModal() {
  editingSensorId = null;
  document.getElementById('edit-modal').classList.add('hidden');
}

async function saveSensorName() {
  const newName = document.getElementById('edit-name').value.trim();
  if (!newName || !editingSensorId) return;
  
  try {
    const response = await fetch(`${API_BASE}/api/sensors/${editingSensorId}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ display_name: newName })
    });
    
    if (response.ok) {
      closeEditModal();
      await fetchSensors();
      await fetchAndRenderChart();
    }
  } catch (error) {
    console.error('Error updating sensor name:', error);
  }
}

function updateConnectionStatus(online) {
  const dot = document.getElementById('connection-status');
  dot.className = `status-dot ${online ? 'online' : 'offline'}`;
}

function formatTimestamp(date) {
  const now = new Date();
  const diff = now - date;
  
  if (diff < 60000) return 'Just now';
  if (diff < 3600000) return `${Math.floor(diff / 60000)}m ago`;
  if (diff < 86400000) return `${Math.floor(diff / 3600000)}h ago`;
  return date.toLocaleDateString();
}

function escapeHtml(text) {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}

document.getElementById('cancel-edit').addEventListener('click', closeEditModal);
document.getElementById('save-edit').addEventListener('click', saveSensorName);
document.getElementById('edit-name').addEventListener('keypress', (e) => {
  if (e.key === 'Enter') saveSensorName();
});

document.getElementById('time-range').addEventListener('change', fetchAndRenderChart);
document.getElementById('show-pm1').addEventListener('change', fetchAndRenderChart);
document.getElementById('show-pm25').addEventListener('change', fetchAndRenderChart);
document.getElementById('show-pm10').addEventListener('change', fetchAndRenderChart);

let firmwarePollingInterval = null;

async function uploadFirmware() {
  if (!confirm('Upload firmware to connected ESP32?\n\nMake sure the device is connected via USB.')) {
    return;
  }
  
  document.getElementById('firmware-modal').classList.remove('hidden');
  document.getElementById('upload-firmware-btn').disabled = true;
  
  const statusEl = document.getElementById('firmware-status');
  const outputEl = document.getElementById('firmware-output');
  
  statusEl.className = 'firmware-status running';
  statusEl.innerHTML = '<span class="status-text">⏳ Uploading firmware...</span>';
  outputEl.textContent = 'Starting upload...\n';
  
  try {
    const response = await fetch(`${API_BASE}/api/firmware/upload`, { method: 'POST' });
    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.detail || 'Upload failed to start');
    }
    
    firmwarePollingInterval = setInterval(pollFirmwareStatus, 1000);
  } catch (error) {
    statusEl.className = 'firmware-status error';
    statusEl.innerHTML = `<span class="status-text">❌ ${error.message}</span>`;
    document.getElementById('upload-firmware-btn').disabled = false;
  }
}

async function pollFirmwareStatus() {
  try {
    const response = await fetch(`${API_BASE}/api/firmware/status`);
    const status = await response.json();
    
    const statusEl = document.getElementById('firmware-status');
    const outputEl = document.getElementById('firmware-output');
    
    outputEl.textContent = status.output || 'Waiting for output...';
    outputEl.scrollTop = outputEl.scrollHeight;
    
    if (!status.running) {
      clearInterval(firmwarePollingInterval);
      firmwarePollingInterval = null;
      document.getElementById('upload-firmware-btn').disabled = false;
      
      if (status.success) {
        statusEl.className = 'firmware-status success';
        statusEl.innerHTML = '<span class="status-text">✅ Upload complete!</span>';
      } else {
        statusEl.className = 'firmware-status error';
        statusEl.innerHTML = '<span class="status-text">❌ Upload failed</span>';
      }
    }
  } catch (error) {
    console.error('Error polling firmware status:', error);
  }
}

function closeFirmwareModal() {
  document.getElementById('firmware-modal').classList.add('hidden');
  if (firmwarePollingInterval) {
    clearInterval(firmwarePollingInterval);
    firmwarePollingInterval = null;
  }
}

async function resetSensorWifi(sensorId) {
  const sensor = sensors.find(s => s.id === sensorId);
  const name = sensor ? sensor.display_name : sensorId;
  
  if (!confirm(`Reset WiFi on ${name}?\n\nThe sensor will restart and broadcast its AP for reconfiguration.`)) {
    return;
  }
  
  try {
    const response = await fetch(`${API_BASE}/api/sensors/${sensorId}/reset-wifi`, { method: 'POST' });
    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.detail || 'Reset failed');
    }
    alert(`WiFi reset triggered on ${name}.\n\nLook for the AirQuality-AP network to reconfigure.`);
  } catch (error) {
    alert(`Failed to reset WiFi: ${error.message}`);
  }
}

fetchSensors();
fetchAndRenderChart();
setInterval(fetchSensors, REFRESH_INTERVAL);
setInterval(fetchAndRenderChart, REFRESH_INTERVAL * 6);
