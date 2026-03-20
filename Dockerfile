# Containerize the go application that we have created 
# This is the dockerfile that will be used to build the docker image for our go application
# and run the container

# Started with base image
FROM golang:1.22 as base

# Set the working directory inside the container
WORKDIR /app

# Copy the go.mod and go.sum files to the working directory
COPY go.mod ./

# Download the dependencies
RUN go mod download 

# Copy source code into working directory 
COPY . .

# Buid the application
RUN go build -o main .

#Ruduce the image size using multi stage build
# We will use distroless image to run the application

FROM  gcr.io/distroless/base

#Copy the binary from previous stage 
COPY --from=base /app/main .

#Copy the static file from previous stage 
COPY --from=base /app/static ./static

#Expose the port on which application will run 
EXPOSE 8080

#Command to run the application
CMD ["./main"]