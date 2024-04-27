FROM node:20 as build

WORKDIR /app
COPY . .

ARG VITE_BASE_URL_DEV
RUN touch .env
RUN echo "VITE_BASE_URL_DEV=$VITE_BASE_URL_DEV" >> .env
RUN cat .env

RUN yarn install
RUN yarn run build

FROM nginx:latest

COPY --from=build /app/dist /app/dist
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80/tcp

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]