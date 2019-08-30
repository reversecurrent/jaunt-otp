FROM jaunt:baseotp

# copy gtfs
COPY ./berlin-vbb.gtfs.zip /root/otp

# copy osm pbf
COPY ./berlin-geofabrik.osm.pbf /root/otp

EXPOSE 8080

# Start cmd
# java -Xmx2G -jar otp-0.19.0-shaded.jar --build /home/username/otp --inMemory
CMD ["java", "-Xmx3G", "-jar","/root/otp/otp-1.4.0-shaded.jar", "--build","/root/otp","--basePath","/root/otp","--router","default","--server"]