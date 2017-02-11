#!/usr/bin/env bash


command -v node >/dev/null 2>&1 || (
  nvm install node
  nvm use node
)
