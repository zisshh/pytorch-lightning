FROM public.ecr.aws/x8v8d7g8/mars-base:latest
WORKDIR /app

# Copy repository contents
COPY . .

# Install Python dependencies using pip (compatible with this repo's setup.py/requirements.txt)
RUN python -m pip install --upgrade pip \
 && if [ -f requirements.txt ]; then python -m pip install -r requirements.txt; fi \
 && python -m pip install -e .

# Default to interactive shell for development
CMD ["/bin/bash"]
