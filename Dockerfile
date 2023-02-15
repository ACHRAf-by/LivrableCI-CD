# Dockerfile to build a flask app
FROM python:3.9

# Set working directory
WORKDIR /app

# Copy the requirements file
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the source code to the container
COPY . .

# Set the default command to run when the container starts
CMD [ "python", "app.py" ]
