# 1. Documenting Architecture Decisions

Date: 2023-11-16

## Status

Accepted

## Context

Our objective is to enhance the quality of images and video thumbnails.

## Decision

Given that mobile devices often feature high pixel density screens, such as Retina displays, resulting in more pixels packed into a smaller area and delivering sharper, clearer images, it is imperative to factor in the pixel density of the device when resizing images.

Choosing an Appropriate Size: Instead of arbitrarily selecting a fixed size like 500x500 for thumbnails, we recommend dynamically calculating the size based on specific needs. For instance, if a thumbnail of size 75x75 is required, the pixel density of the mobile device should be taken into consideration. Therefore, the new thumbnail size should be calculated as (75 * devicePixelRatio) x (75 * devicePixelRatio), where devicePixelRatio represents the number of device pixels for each logical pixel on the screen. More details can be found [here](https://github.com/fluttercandies/flutter_photo_manager/issues/579).

## Consequences

This decision results in higher-quality images, with minimal impact on performance.
