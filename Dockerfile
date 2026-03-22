# Containerize the go application that we have created 
# This is the dockerfile that will be used to build the docker image for our go application
# and run the container

# Started with base image

FROM golang:1.22.5 As base

# Set the working directory inside the container
WORKDIR /app

# Copy the go.mod and go.sum files to the working directory
COPY go.mod ./

# Download the dependencies
RUN go mod download 

# Copy source code into working directory 
COPY . .

#Disable C dependencies to create a statically linked binary, which is necessary for running the application in a distroless image
ENV CGO_ENABLED=0

# Build the application and create a single binary named main
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

#--------------------------------
# FROM golang:1.22.5 as base #use the official golang image as the base image for the build stage
# Workdir /app #set the working directory inside the container to /app
# Copy go.mod . #copies the dependency file to the working directory 
# Run go mod download  #download the libraries specified in the go.mod file
# Copy . . #copies all your source code to the working directory
# ENV CGO_ENABLED=0 # Disables C dependencies, Creates static binary which is necessary for running the application in a distroless image
# Run build -o main . #complile the application into single binary named main

# From gcr.io/distroless/base #use the distroless image as the base image for the final stage, which is a minimal image that only contains the necessary files to run the application
# Copy --from=base /app/main . #copy the compiled binary from the build stage to the final stage
# Copy --from=base /app/static ./static #copy the static files from the build stage to the final stage
# Expose 8080 #expose the port on which the application will run
# CMD [ "./main" ] #specify the command to run the application when the container starts, which is to execute the main binary

