# SPDX-FileCopyrightText: 2020 SAP SE or an SAP affiliate company and Gardener contributors
#
# SPDX-License-Identifier: Apache-2.0

REGISTRY         := eu.gcr.io/gardener-project
IMAGE_REPOSITORY := $(REGISTRY)/docs-toolbelt
IMAGE_TAG        := $(shell cat VERSION)

#################################################################
# Rules related to binary build, Docker image build and release #
#################################################################

.PHONY: release
release: docker-image docker-login docker-push

.PHONY: docker-image
docker-image:
	@docker build -t $(IMAGE_REPOSITORY):$(IMAGE_TAG) -t $(IMAGE_REPOSITORY):latest -f docker/Dockerfile --rm .

.PHONY: docker-login
docker-login:
	@gcloud auth activate-service-account --key-file .kube-secrets/gcr/gcr-readwrite.json

.PHONY: docker-login-local
docker-login-local:
	@gcloud auth

.PHONY: docker-push
docker-push:
	@if ! docker images $(IMAGE_REPOSITORY) | awk '{ print $$2 }' | grep -q -F $(IMAGE_TAG); then echo "$(IMAGE_REPOSITORY) version $(IMAGE_TAG) is not built yet. Please run 'make docker-images'"; false; fi
	@docker push $(IMAGE_REPOSITORY):$(IMAGE_TAG)

.PHONY: docker-push-kind
docker-push-kind:
	@kind load docker-image $(IMAGE_REPOSITORY):$(IMAGE_TAG)

#####################################################################
# Rules for verification, formatting, linting, testing and cleaning #
#####################################################################

.PHONY: check-compliance
check-compliance:
	@.ci/compliance
