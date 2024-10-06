import docker
import os
import time
from flask import Flask, jsonify

app = Flask(__name__)
client = docker.from_env()

def fetch_container_metrics(container_name):
    try:
        container = client.containers.get(container_name)
        stats = container.stats(stream=False)

        # Extract memory and CPU usage from stats
        memory_usage = stats['memory_stats']['usage']
        cpu_usage = stats['cpu_stats']['cpu_usage']['total_usage']

        # Prepare a dictionary with the metrics
        metrics = {
            "container_name": container_name,
            "memory_usage_bytes": memory_usage,
            "cpu_usage_nanoseconds": cpu_usage,
        }
        return metrics

    except docker.errors.NotFound:
        return {"error": f"Container {container_name} not found!"}

@app.route('/metrics', methods=['GET'])
def metrics():
    container_name = os.getenv('CONTAINER_NAME', 'main_app')  # Use env variable
    container_metrics = fetch_container_metrics(container_name)
    return jsonify(container_metrics)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)  # Expose on port 5000
