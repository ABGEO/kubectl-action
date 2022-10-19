# kubectl

GitHub Action for interacting with kubectl

## Usage

```yaml
- uses: abgeo/kubectl-action@1.25.3
  env:
    KUBE_HOST: ${{ secrets.KUBE_HOST }}
    KUBE_CERTIFICATE: ${{ secrets.KUBE_CERTIFICATE }}
    KUBE_TOKEN: ${{ secrets.KUBE_TOKEN }}
    KUBE_NAMESPACE: ${{ secrets.KUBE_NAMESPACE }}
```

## Environment variables

To work with this action you have to create service account with all the necessary RBAC permissions.
After you create the account you should retrieve `ca.crt` and `token` from its secret. We will use those values later.

| Variable         | Type   | Description                                  |
|------------------|--------|----------------------------------------------|
| KUBE_HOST        | string | Hostname of your cluster (without protocol!) |
| KUBE_CERTIFICATE | string | base64-encrypted value of `ca.crt` secret    |
| KUBE_TOKEN       | string | `token` secret                               |
| KUBE_NAMESPACE   | string | k8s namespace of your service account        |

## Example

```yaml
name: Get Pods
on: [ push ]

jobs:
  pods:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v2

      - uses: abgeo/kubectl-action@1.25.3
        env:
          KUBE_HOST: ${{ secrets.KUBE_HOST }}
          KUBE_CERTIFICATE: ${{ secrets.KUBE_CERTIFICATE }}
          KUBE_TOKEN: ${{ secrets.KUBE_TOKEN }}
          KUBE_NAMESPACE: ${{ secrets.KUBE_NAMESPACE }}
        with:
          arg: get pods
```

```yaml
name: Deploy API
on: [ push ]

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v2

      - name: Setup kubectl
        uses: abgeo/kubectl-action@1.25.3
        env:
          KUBE_HOST: ${{ secrets.KUBE_HOST }}
          KUBE_CERTIFICATE: ${{ secrets.KUBE_CERTIFICATE }}
          KUBE_TOKEN: ${{ secrets.KUBE_TOKEN }}
          KUBE_NAMESPACE: ${{ secrets.KUBE_NAMESPACE }}

      - name: kubectl get deployments
        uses: abgeo/kubectl-action@1.25.3
        with:
          arg: get deployments

      - name: kubectl apply
        uses: abgeo/kubectl-action@1.25.3
        with:
          arg: apply -f deployments.yaml
```

## Authors

- [Temuri Takalandze](https://abgeo.dev) - *Maintainer*

## License

Copyright (c) 2022 [Temuri Takalandze](https://abgeo.dev).  
Released under the [GPL-3.0](LICENSE) license.
