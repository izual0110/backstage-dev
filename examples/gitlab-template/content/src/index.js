const http = require('node:http');

const port = Number(process.env.PORT ?? 3000);
const server = http.createServer((_request, response) => {
  response.writeHead(200, { 'content-type': 'application/json' });
  response.end(JSON.stringify({ service: '${{ values.name }}', status: 'ok' }));
});

server.listen(port, () => {
  console.log(`Service is listening on port ${port}`);
});
