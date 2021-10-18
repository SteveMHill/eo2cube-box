.PHONY: up init 

up:
	docker-compose up -d postgres
	docker-compose up -d jupyter

down:
	docker-compose down

build: 
	docker-compose pull
	docker-compose build

shell:
	docker-compose exec jupyter bash

clean:
	docker-compose down --rmi all -v

logs: 
	docker-compose logs --follow

init:
	docker-compose exec -T jupyter datacube -v system init

s2_product:
	docker-compose exec -T jupyter datacube -v product add ../products/s2_l2a.yaml

s2_index:
	docker-compose exec -T jupyter bash -c "stac-to-dc \
			--bbox='9.80,49.70,10.1,49.85' \
			--catalog-href='https://earth-search.aws.element84.com/v0/' \
			--collections='sentinel-s2-l2a-cogs' \
			--datetime='2021-06-01/2021-07-01'"
