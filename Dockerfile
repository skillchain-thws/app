FROM node:20-alpine

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

WORKDIR /app

COPY . /app
RUN --mount=type=cache,id=pnpm,target=/pnpm/store \
    pnpm install --ignore-scripts --frozen-lockfile
RUN pnpm be:build && pnpm fe:build

EXPOSE 8545
EXPOSE 4173

ENTRYPOINT ["/bin/sh", "./entrypoint.sh"]
