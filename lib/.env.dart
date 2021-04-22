// const bool isProduction = bool.fromEnvironment('dart.vm.product');
const bool isProduction = false;

const testConfig = {
  "online": false,
  "base_url": "api.themoviedb.org",
  "api_key": "8b46eb7932c02a8ea99e8c6db9de4ffd"
};
const productionConfig = {
  "online": true,
  "base_url": "api.themoviedb.org",
  "api_key": "8b46eb7932c02a8ea99e8c6db9de4ffd"
};

final environment = isProduction ? productionConfig : testConfig;
