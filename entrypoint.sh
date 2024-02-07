#!/bin/sh

cd /app;

pnpm be:node &

npx wait-on http://127.0.0.1:8545 && pnpm be:deploy:local && pnpm fe:preview --host;

wait $!
