#stage 1
# FROM node:latest as node
# WORKDIR /app
# COPY . .
# RUN npm install
# RUN npm run build 
# #stage 2
# FROM nginx:alpine
# COPY --from=node /app/dist/canteen-management-system /usr/share/nginx/html
# COPY /nginx.conf  /etc/nginx/conf.d/default.conf

# EXPOSE 80
# ### STAGE 1:BUILD ###
# # Defining a node image to be used as giving it an alias of "build"
# # Which version of Node image to use depends on project dependencies 
# # This is needed to build and compile our code 
# # while generating the docker image
# FROM node:12.14-alpine AS build
# # Create a Virtual directory inside the docker image
# WORKDIR /dist/src/app
# # Copy files to virtual directory
# # COPY package.json package-lock.json ./
# # Run command in Virtual directory
# # Copy files from local machine to virtual directory in docker image
# COPY . .
# RUN npm install
# RUN npm run build 


# ### STAGE 2:RUN ###
# # Defining nginx image to be used
# FROM nginx:latest AS ngi
# # Copying compiled code and nginx config to different folder
# # NOTE: This path may change according to your project's output folder 
# COPY --from=build /dist/src/app/dist/canteen-management-system /usr/share/nginx/html
# COPY /nginx.conf  /etc/nginx/conf.d/default.conf
# # Exposing a port, here it means that inside the container 
# # the app will be using Port 80 while running
# EXPOSE 80
# ..........................................................................

# base image
FROM node:16-alpine as node
# set working directory
WORKDIR /app

# install and cache app dependencies
COPY . .
RUN npm install
RUN npm run build --prod

FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/* && rm -rf /etc/nginx/nginx.conf
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY --from=node /app/dist/DSP-UI /usr/share/nginx/html
