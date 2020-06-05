# Directions API Report

## How to set the response format

output flag

## What are the returns of directions lookups

One entry, unless passed with alternatives=true flag.

## How to use the response

Parse the results as JSON

## Geocoded Waypoints

An array with origin, waypoints, and destination detail

### Geocoder Status

### Partial Match

Match when having spelling errors

### Place ID

### Types

#### Street Address

#### route

#### intersection

## Routes

Legs and Steps from origin to the destination.

### How are the results stored

JSON routes array.

### What are the elements of routes

A single result from origin to destination

### How may legs are there in a route

One or more if way points are specified.

### What are the in the routes array?

Summary, legs, way point order, overview polyline, bounds, copyrights, warnings, and fare.

### Summary

Short description

### Legs

#### What is a leg

A segment from the origin to the destination

#### Steps

Step for each leg

#### distance

##### Value

##### Text

#### duration

##### value

Duration in seconds

##### text

#### duration in traffic

Duration with traffic conditions

#### Arrival Time

Returns Time object with Data object, text string, and time_zone

#### Start Location

Coordinates

#### End Location

Coordinates

#### Start Address

#### End Address

## Travel modes

Available travel modes
