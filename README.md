# `docker-spotbugs`

Run SpotBugs against a local Java repository.


## `docker build`

Build the image using:

```bash
docker build -t spotbugs .
```


## `docker run`

Assuming you're in your application root and have successfully
compiled your application, leaving you a `build/` directory:

```bash
docker run \
    --interactive \
    --tty \
    --rm \
    --volume $(pwd)/build:/spotbugs/build \
    spotbugs > report.html
```

The resulting `report.html` can now be viewed.

