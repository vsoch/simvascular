# SimVascular

This is a Docker build of SimVascular, intended to be run with Singularity.
The binary is not included here, but you can get it [from their site]().

The intended use case is the following:

# Usage

## Run via Singularity


The easiest thing to do is then run via Singularity

```bash
singularity pull --name simvascular docker://vanessa/simvascular
singularity run simvascular
```

# Development

## Build
If you re-obtain a new binary, you can build like this. Note that you will
need to update the [Dockerfile](Dockerfile) with the version you downloaded.

```bash
docker build -t vanessa/simvascular .
```

## Push

You can then tag and push to Dockerhub (this is how @vsoch does it)

```bash
docker tag vanessa/simvascular:latest vanessa/simvascular:2018-11-25
docker push vanessa/simvascular
```

