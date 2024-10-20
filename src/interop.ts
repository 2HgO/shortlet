export const flags = ({ env }) => {
  // ...
  const { BASE_URL } = env;
  return { base_url: BASE_URL };
}

// ...

export const onReady = ({ app, env }) => {
  // ...
}
