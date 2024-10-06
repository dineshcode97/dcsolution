FROM python:3.9-slim

# Install Flask and docker Python SDK
RUN pip install docker flask

# Copy the Python script into the container
COPY fetch_metrics.py /usr/src/app/fetch_metrics.py

# Set the working directory
WORKDIR /usr/src/app

# Expose the Flask web server port
EXPOSE 5000

# Run the Flask app
CMD ["python", "fetch_metrics.py"]
