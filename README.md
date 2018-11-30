# SimVascular

This is a Docker build of SimVascular, intended to be run with Singularity.
The binary is not included here, but you can get it [from their site]().

The intended use case is the following:

# Usage

## Run via Singularity

The easiest thing to do is then run via Singularity. You can pull the container
first.

```bash
singularity pull --name simvascular docker://vanessa/simvascular
```

## Run the simvascular interface

By default, the container entrypoint is to the executable `simvascular` that will
open up the interface:

```bash
singularity run simvascular
```

If you want to use the solver, do this:

```bash
singularity exec simvascular svsolver
```

or the svfsi solver (not sure about the difference)

```bash
singularity exec simvascular svfsi
```

# Development

## Build

If you re-obtain a new binary, you can build like this. Note that you will
need to update the [Dockerfile](Dockerfile) with the version you downloaded.

```bash
docker build -t vanessa/simvascular .
```

## Push

You can then tag and push to Dockerhub (this is how @vsoch does it) to
the repository [vanessa/simvascular](https://hub.docker.com/r/vanessa/simvascular/).

```bash
docker tag vanessa/simvascular:latest vanessa/simvascular:2018-11-25
docker push vanessa/simvascular
```

