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

# the following 2 are needed for the Heroku deploy only
COPY ./nginx.conf /etc/nginx/conf.d/default.conf                            
RUN rm -rf /usr/share/nginx/html/*


# AWS ElasticBeanstalk looks at the following to expose the app to the outside world
EXPOSE 80
# builder comes from Phase 1
COPY --from=builder /app/build /usr/share/nginx/html

# the following 3 are needed for the Heroku deploy only
COPY --from=builder /app/entrypoint.sh /usr/share/nginx/
RUN chmod +x /usr/share/nginx/entrypoint.sh
CMD ["/bin/sh", "/usr/share/nginx/entrypoint.sh"]

# CMD --> starts nginx by default