# Production environment
# AWS EBS used for prod deployment - it auto uses this file

# Phase 1 - temporary container to build our React app
FROM node:alpine as builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY ./ ./
RUN npm run build

# Phase 2 - the final container will contain only the build folder with our built React app
# nginx is web server we use to host our static React app content
FROM nginx:alpine

# AWS ElasticBeanstalk looks at the following to expose the app to the outside world
EXPOSE 80

# builder comes from Phase 1
COPY --from=builder /app/build /usr/share/nginx/html
# CMD --> starts nginx by default