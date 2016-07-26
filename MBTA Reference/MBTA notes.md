### Desired Routes

- Orange Line Inbound towards Forest Hills
- CT2 Inbound towards Ruggles
- 86 Inbound towards Reservoir
- 90 Inbound towards Davis
- 91 Inbound towards Central

### Stop IDs

- Sullivan Upper Busway: `2874`
- Sullivan Lower Busway: `28741`
- Orange Line Sullivan Outbound: `70031`
- Orange Line Sullivan Inbound: `70030`
- Sullivan Station: `place-sull`


### Route IDs

> https://realtime.mbta.com/developer/api/v2/routesbystop?api_key=wX9NwuHnZU2ToO7GmGR9uw&stop=place-sull&format=json

```json
{
    "mode": [
        {
            "mode_name": "Subway",
            "route": [
                {
                    "route_id": "Orange",
                    "route_name": "Orange Line"
                }
            ],
            "route_type": "1"
        },
        {
            "mode_name": "Bus",
            "route": [
                {
                    "route_id": "747",
                    "route_name": "CT2"
                },
                {
                    "route_id": "86",
                    "route_name": "86"
                },
                {
                    "route_id": "90",
                    "route_name": "90"
                },
                {
                    "route_id": "91",
                    "route_name": "91"
                },
            ],
            "route_type": "3"
        }
    ],
    "stop_id": "place-sull",
    "stop_name": "Sullivan Square"
}
```
