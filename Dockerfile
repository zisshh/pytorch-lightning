FROM public.ecr.aws/x8v8d7g8/mars-base:latest
WORKDIR /app

# Copy repository contents
COPY . .

# Install Python dependencies using uv (respects pyproject + lock)
RUN uv sync --frozen

# Default to interactive shell for development
CMD ["/bin/bash"]
