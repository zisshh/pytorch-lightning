FROM public.ecr.aws/x8v8d7g8/mars-base:latest
WORKDIR /app

# Copy repository contents
COPY . .

# Install Python dependencies using uv
# If a lockfile is present, install in frozen mode. Otherwise, create one first.
RUN (test -f uv.lock && uv sync --frozen) || (uv lock && uv sync --frozen)

# Default to interactive shell for development
CMD ["/bin/bash"]
