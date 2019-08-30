FROM openjdk:8-jre-alpine

# Copy OTP jar
COPY ./binaries/otp-1.4.0-shaded.jar /root/otp/