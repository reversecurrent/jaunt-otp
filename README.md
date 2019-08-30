# OTP 
Open Trip Planner is a multi-modal trip planning software. Jaunt product uses
OTP as the route provider for trips and transit.

# Workflow
* Create Base OTP Docker image
* Create Router-specific OTP Docker image 
     - GTFS.zip, OSM.PDB mounted on host volume
* Run routes
    - Run the container. 
    - Run the OTP
    - This should produce the graph which will be stored on the mounted volume
* Create Router-Graph OTP Docker image
    - Graph for the router run in the above step

## Get OTP
	• OTP is built in Java and is available as a single runnable JAR.
	• Available at Maven Central.
	• Go to: https://repo1.maven.org/maven2/org/opentripplanner/otp/
	• Navigate to the directory for the highest version number
	• Download file whose name ends with .shaded.jar
    • Copy to ./jaunt-otp/binaries

## Create Base OTP Docker image
1. CD to jaunt-otp folder
2. Run the following command to build the docker image:
       docker build -f BaseOTP.dockerfile --tag jaunt:baseotp .
3. See the docker image by running the following command:
        docker images

## Create Router-specific OTP Docker image 
Pre-requisite: Ensure you have completed the above 2 tasks
1. CD to jaunt-otp/routers/<region> folder
2. Download GTFS
    - Copy the .zip file under a specific folder in routers. For eg: routers/berlin/        berlin-vbb.gtfs.zip  (use the convention of : <region>-<provider>.gtfs.zip )
3. Download OSM PBF data for the same geographic region as GTFS feed
    - Copy PBF file in the same directory as GTFS feed
    - use the convention of : <region>-<provider>.osm.pbf
4. Build the router-specific docker image :
    docker build -f berlin-router.dockerfile --tag jaunt:berlin-otp .
5. Build the region specific graph by running the container based on the above created image:
    docker container run -p 8080:8080 --name jaunt-berlin-otp-server jaunt:berlin-otp
    

## Get GTFS
 Best option is to fetch directly from a transit operator or agency  
 Use 3rd party feeds : https://transit.land/feed-registry , http://transitfeeds.com/

## Get OSM PBF
Some feeds:
   https://download.geofabrik.de/europe/germany/berlin.html

## Run OTP 
#### Build Graph
java -jar otp-1.4.0-shaded.jar --build ./ --basePath ./ --router default; 
#### Run OTP API server with the built in graph
java -jar otp-1.4.0-shaded.jar --graphs ./graphs --router default --server
On success, this should show a message: (GrizzlyServer.java:153) Grizzly server running.

## Get Data from OTP
By default, OTP runs on port 8080. 
Web client is available at http://localhost:8080
APIs are available at respective end points after the base URL

Learnings:
What base image to choose for jre : https://medium.com/@hudsonmendes/docker-spring-boot-choosing-the-base-image-for-java-8-9-microservices-on-linux-and-windows-c459ec0c238
Docker Operations:
* Create a docker image using docker build
* Listing docker images using : docker images

## Issues when running OTP
1. Out of memory exception
      Provide sufficient memory using -Xmx2G. 2G represents 2G of memory. Increase if required
2. Error parsing GTFS
        - missing required field: agency_url
            Go to agency.txt and ensure agency_url has URL value
        - BVG GTFS feed didn't work with OTP as data sanity was not passed
        -   Downloaded from http://transitfeeds.com/p/verkehrsverbund-berlin-brandenburg/213
3. Unable to run OTP in a docker container. So running on the host for now. Revisit later to fix



