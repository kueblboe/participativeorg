# participative*org*

This application aims to enable decentralized decision-making within participative organizations by providing transparency about slack, peer ranking, economics and guidelines.

[Desire engine](http://www.slideshare.net/nireyal/hooked-model) for slack feature

- Trigger: internal (planning slack), external (email notifications)
- Action: enter slack activities
  - Motivation: seeking acceptance
- Reward: Tribal recognition (like, comments)
- Investment: data

## Contribute

### Adding features

- Optimize for maintainability. Be obvious, not clever.
- **K**eep **I**t **S**imple **S**tupid
- Think of "LOC spent". Is this new feature worth the added complexity?

### Coding style

- Use functional style (e.g. [underscorejs](http://underscorejs.org/) instead of loops) Don't know how? [Learn it here.](http://reactive-extensions.github.io/learnrx/)

### Design  guidelines

- simple
- elegant
- subtle
- default to white

### Running the app locally
You need to install `node.js` first. If you have brew installed you can do it like this:

```sh
brew install node
```

You also need to istall `meteorite`:

```sh
npm install -g meteorite
```

To install the smart packages use:

```sh
mrt install
```

To start the app use

```sh
meteor
```

The app is running at `http://localhost:3000/` now

### Running the tests
To run the tests you need jasmine-node, use NPM:

```sh
npm install -g jasmine-node
```

Now you can run the tests with:

```sh
jasmine-node --verbose --coffee tests/
```

To run the tests automatically all the time after saving a file use:

```sh
jasmine-node --autotest --color --verbose --coffee tests/
```