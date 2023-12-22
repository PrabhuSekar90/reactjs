### STAGE 1: Build ### 
FROM node:lts-alpine AS build

#### make the 'app' folder the current working directory
WORKDIR /usr/src/app

#### copy both 'package.json' and 'package-lock.json' (if available)
COPY package*.json ./

#### install project dependencies
RUN npm install

#### copy things
COPY . .

RUN npm run build


### STAGE 2: Run ###
FROM nginxinc/nginx-unprivileged

#### copy nginx conf
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

#### copy artifact build from the 'build environment'
COPY --from=build /usr/src/app/build /usr/share/nginx/html
COPY --from=build /usr/src/app/build/static /usr/share/nginx/html/bmi-calculator/static

EXPOSE 8080

#### don't know what this is, but seems cool and techy
CMD ["nginx", "-g", "daemon off;"]