# Webhooks for GoCD

This docker image hosts a [webhook](https://github.com/adnanh/webhook) receiver
for GoCD.

Currently onyl one webhook for Gitea is configured. But any other Git server can
be added easily to *hooks.json*. See
[documentation](https://github.com/adnanh/webhook/blob/master/docs/Hook-Examples.md)
on how to define hooks.

For GoCD API authorisation an admin-user's access token is required. See
[documentation](https://docs.gocd.org/current/configuration/access_tokens.html).
The GoCD *material URL* has to match the URL sent with the webhook to shedule
the material for update.

- For Gitea the URL is in the json payload at *repository.clone_url*

## Prerequisites

- Docker
- GoCD server >= v19.6.0
- Gitea server >= 1.9

## Run

```sh
docker run \
 --name webhook \
 -p 9000:9000 \
 -e GO_API_TOKEN="GO_ADMIN_USER_TOKEN" \
 -e GO_SERVER_URL="http://gocd-server:8153" \
 pasientskyhosting/gocd-webhooks
```

To serve secure content using *HTTPS*, you need to provide the following
parameters:

```sh
docker run \
 --name webhook \
 -p 9000:9000 \
 -e GO_API_TOKEN="GO_ADMIN_USER_TOKEN" \
 -e GO_SERVER_URL="http://gocd-server:8153" \
 -secure \
 -cert /path/to/cert.pem \
 -key /path/to/key.pem \
 pasientskyhosting/gocd-webhooks
```

## Configuration

### Gitea

Either configure a global webhook via *Site Administration -> Default Webhooks*
or configure webhooks per repository *Settings -> Webhooks*.

| Parameter         | Value                           |
|-------------------|---------------------------------|
|   Target URL      | http://webhook:9000/hooks/gitea |
|   HTTP Method     | POST                            |
|   Content Type    | application/json                |
|   Secret          | WEBHOOK_SECRET                  |

## Troubleshooting

### Enable verbose mode

```sh
docker run \
 --name webhook \
 -p 9000:9000 \
 -e GO_API_TOKEN="GO_ADMIN_USER_TOKEN" \
 -e GO_SERVER_URL="http://gocd-server:8153" \
 pasientskyhosting/gocd-webhooks -template -hooks=/opt/webhook/hooks.json -verbose
```
