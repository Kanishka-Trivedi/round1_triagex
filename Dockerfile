FROM node:20-alpine

# Create app directory
WORKDIR /usr/src/app

# Copy server package.json and install dependencies
COPY server/package*.json ./server/
WORKDIR /usr/src/app/server
RUN npm install

# Copy all server files
COPY server/ .

# We also need to copy the openenv.yaml into the root folder or where expected
WORKDIR /usr/src/app
COPY openenv.yaml .

# Export port (default 7860 for TRIAGE-X)
# HF Spaces will use port 7860 by default.
ENV PORT=7860

EXPOSE 7860

WORKDIR /usr/src/app/server
CMD [ "npm", "start" ]
