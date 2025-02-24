# Builder stage
FROM golang:1.24.0-alpine3.21 AS builder

# Working directory for the build stage
WORKDIR /app/src

# Copy dependency files first to leverage Docker cache
COPY src/go.mod src/go.sum ./

# Download dependencies
RUN go mod download

# Copy all source files
COPY src/ ./

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/bin/go-app ./cmd/go-app/main.go



# Final stage
FROM golang:1.24.0-alpine3.21

# Working directory for runtime
WORKDIR /app

# Copy binary from builder
COPY --from=Builder /app/bin/go-app .

# Copy config files
COPY src/config/ ./config/

# Expose port
EXPOSE 8080

# Command to run the application
CMD [ "./go-app" ]