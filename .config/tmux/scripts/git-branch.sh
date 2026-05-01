#!/bin/bash
git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "No branch"

