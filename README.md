# SimVascular and SvSolver

These are Docker builds of SimVascular and SvSolver intended to be run with Singularity.
It clones and builds simvascular from the [SimVascular](https://github.com/Simvascular/SimVascular) repository
master branch, and SvSolver from [it's respective repository](https://github.com/Simvascular/SimVascular). 
If you intend to use this to build a container for research,
you should customize the Dockerfile build to install a release.

**Note** The Dockerfiles here are redundant in having one per openmpi version -
we will want to make a build recipe with a grid of builds that provide the bases and
MPI flavors and versions that are most commonly needed as build args.

The intended use case is the following:

# SimVascular

 - [SimVascular with OpenMPI version 1.10.7](https://hub.docker.com/r/vanessa/simvascular) tags latest and 2020-04 built from [Dockerfile.simvascular](Dockerfile.simvascular)

## Build

Clone the repository

```bash
git clone https://github.com/vsoch/simvasvular
cd simvascular
```

Build the container, and tag:

```bash
docker build -t vanessa/simvascular .
docker tag vanessa/simvascular:latest vanessa/simvascular:2020-04
```

You can then pull directly from your Docker daemon:

```bash
singularity pull docker-daemon://vanessa/simvascular:2020-04
```

You can transfer (e.g., with scp) the container, or even better, 
if you want you can push to some Docker Registry to share or pull from another
host (e.g., your cluster):

```bash
# pushes all tags
docker push vanessa/simvascular
singularity pull docker://vanessa/simvascular:2020-04
```

## Usage


### Singularity

The easiest thing to do is then run via Singularity. You can pull the container
first (see above) and then run the container:

```bash
singularity run simvascular_2020-04.sif
```

By default, the container entrypoint is to the executable `simvascular` that will
open up the interface:

![img/simvascular.png](img/simvascular.png)

If you want to use the solver, do this:

```bash
singularity exec simvascular svsolver

The process ID for myrank (0) is (23395).


The number of processes is 1.

Solver Input Files listed as below:
------------------------------------
 Local Config: solver.inp 
 Input file does not exist or is empty or perhaps you forgot mpirun?
```

or the svfsi solver (not sure about the difference) - note that you need mpi 1.10 on the
host for this to work. You probably don't have it (it's not on Sherlock). Sorry. See
[this issue](https://github.com/SimVascular/SimVascular/issues/368#issuecomment-443385120) 
to see why it's needed and there's nothing I can do about it.

```bash
singularity exec simvascular svfsi
```

Note that if you are on sherlock, you can always load additional libraries that you need,
a simple search with spider looks like this:

```bash
module spider mpi
```

# svSolver

All containers are on Docker Hub under [vanessa/svsolver](https://hub.docker.com/r/vanessa/svsolver).
Associated Dockerfiles and tags include:

 - [Dockerfile.svsolver](Dockerfile.svsolver) builds svsolver with OpenMPI version 1.10.7, tags latest and 2020-04
 - [Dockerfile.svsolver-openmpi-3.1.4](Dockerfile.svsolver-openmpi-3.1.4) builds svsolver with OpenMPI version 3.1.4, tags openmpi-3.1.14

These Dockerfiles are reudundant and should be replaced with build args to determine versions.

## Build

You can again build the svSolver from the [svSolver](Dockerfile.svsolver) Dockerfile.

```bash
docker build -f Dockerfile.svsolver -t vanessa/svsolver .
docker tag vanessa/svsolver:latest vanessa/svsolver:2020-04
```

And pull with Singularity from your docker daemon.

```bash
singularity pull docker-daemon://vanessa/svsolver
```

You can also push to a Docker registry to pull to some host:

```bash
docker push vanessa/svsolver
singularity pull docker://vanessa/svsolver:2020-04
```

## Usage

### Docker

You can try running the Docker container, but it likely isn't so useful without MPI:

```bash
$ docker run -it vanessa/svsolver

The process ID for myrank (0) is (1).


The number of processes is 1.

Solver Input Files listed as below:
------------------------------------
 Local Config: solver.inp 
 Input file does not exist or is empty or perhaps you forgot mpirun? 
```

### Singularity

For Singularity, you can first pull the image from your remote registry:

```bash
singularity pull docker://vanessa/svsolver:2020-04
```

The entrypoint is to binaries in /code/svSolver/BuildWithMake/Bin, which
are intended for linux but have .exe extensions:

```bash
$ docker run -it --entrypoint bash vanessa/svsolver
root@47d1dee35d17:/code# ls svSolver/BuildWithMake/Bin/
svpost-gcc-gfortran.exe  svpost.exe  svpre-gcc-gfortran.exe  svpre.exe  svsolver-gcc-gfortran-nompi.exe  svsolver-nompi.exe
```

The current entrypoint is "svsolver-nompi.exe," indicating that there is no MPI,
however ideally there would be automated builds providing several versions of MPI
inside the container.
