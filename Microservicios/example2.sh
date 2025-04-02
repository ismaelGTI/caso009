name: CI/CD para Microservicios
run-name: Ejecutado por ${{ github.actor }}

on: 
  push:
    branches:
      - main
  workflow_dispatch:

jobs:
  detect-changes:
    runs-on: ubuntu-latest
    outputs:
      changed_services: ${{ steps.set-changes.outputs.changed_services }}
    steps:
      - name: Clonar repositorio
        uses: actions/checkout@v4

      - name: Detectar microservicios modificados
        id: detect
        uses: tj-actions/changed-files@v34
        with:
          files: |
            Microservicios/**/*
        
      - name: Establecer microservicios modificados
        id: set-changes
        run: |
          changed_services=$(echo ${{ steps.detect.outputs.all_changed_files }} | grep -o 'Microservicios/[^/]*' | sort -u | paste -sd ',' -)
          if [ -z "$changed_services" ]; then
            echo "changed_services=[]" >> $GITHUB_OUTPUT
          else
            echo "changed_services=$changed_services" >> $GITHUB_OUTPUT
          fi

  build-and-deploy:
    needs: detect-changes
    runs-on: ubuntu-latest
    strategy:
      matrix:
        service: ${{ fromJSON(needs.detect-changes.outputs.changed_services) }}
    steps:
      - name: Clonar repositorio
        uses: actions/checkout@v4

      - name: Ejecutar script de CI/CD
        run: |
          if [ -f ${{ matrix.service }}/example1.sh ]; then
            bash ${{ matrix.service }}/example1.sh
          elif [ -f ${{ matrix.service }}/example2.sh ]; then
            bash ${{ matrix.service }}/example2.sh
          elif [ -f ${{ matrix.service }}/example3.sh ]; then
            bash ${{ matrix.service }}/example3.sh
          else
            echo "No se encontró ningún script para ejecutar en ${{ matrix.service }}"
