FROM node:20-alpine as build-stage
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

WORKDIR /app

COPY . /app
RUN --mount=type=cache,id=pnpm,target=/pnpm/store \
    pnpm install --ignore-scripts --frozen-lockfile
RUN pnpm build

FROM nginx:stable-alpine as production-stage

COPY --from=build-stage /app/frontend/dist /usr/share/nginx/html
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
