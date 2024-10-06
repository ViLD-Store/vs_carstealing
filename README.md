# vs_carstealing

### Bring the excitement of car theft to your FiveM server with `vs_carstealing`

This script offers an immersive and thrilling experience for players looking to engage in car theft missions. Players can receive tasks, hack vehicles, and deliver stolen cars for rewards—all while avoiding the police or rival gangs. It’s the perfect addition for servers with a focus on roleplay or an economy-driven game loop.

## Features

- **Task System:** Players receive randomized car theft missions from an NPC, keeping gameplay fresh and unpredictable.
- **Signal Scanner:** Track down the target vehicle using a signal scanner, guiding players within a defined radius on the map.
- **Hacking Minigame:** A skill-based minigame to hack into the car's security system and unlock the key signal.
- **Steal & Deliver:** Once unlocked, players can steal the vehicle and deliver it to a designated drop-off location for a reward.
- **Pedro NPC Interaction:** The player interacts with Pedro, the NPC buyer, to turn in the stolen car and receive payment.
- **Fully Configurable:** Easily adjust mission parameters such as locations, rewards, scanner range, and difficulty to fit your server's needs.
- **Immersive Roleplay Experience:** Add depth and realism to your server's criminal gameplay with an engaging, high-stakes car theft system.

## Preview

Check out a sneak peek of `vs_carstealing` in action!

[vs_carstealing Preview](https://streamable.com/im54rm)

---

## Installation

1. Download the `vs_carstealing` script from this repository.
2. Extract the contents to your FiveM server's `resources` folder.
3. Add `ensure vs_carstealing` to your server's `server.cfg` file.
4. Customize the configuration to fit your server's preferences (details below).
5. Restart your server and enjoy!

## Configuration

The script comes with a highly configurable setup to fit your server's unique gameplay style. You can modify the following settings in the `config.lua` file:

### General Settings

- **Language Support:**
  - `Config.Lang`: Set the language used in the game (default is `'en'`).
  - Modify messages in `Config.Language` to localize the experience.

- **Framework Integration:**
  - `Config.Bridge.Notification`: Choose the notification system (supports `ESX`, `QB`, `OKOK`, `OX`, `mythic`, or `CUSTOM`).
  - `Config.Bridge.MiniGame`: Select the type of minigame used for hacking (`'path'`, `'spot'`, or `'math'`).

- **Police Integration:**
  - `Config.PoliceJob`: Set the name of the police job on your server (default: `'police'`).
  - `Config.PoliceJobs`: Minimum number of online police officers required to initiate a mission.

### Mission Settings

- **Wait Times:**
  - `Config.Wait.Found`: Time (in milliseconds) the player has to wait after finding the vehicle.
  - `Config.Wait.Cooldown`: Cooldown period before players can steal another car.
  - `Config.Wait.WhenPlayerCanGoSell`: Time to wait before players can deliver the vehicle to the buyer.

- **Stealing Cars:**
  - **NPC Configuration:**
    - `Config.Stealing_Cars.Ped.Ped`: Set the NPC model for the mission giver.
    - `Config.Stealing_Cars.Ped.Loc`: Define the NPC’s location.
  - **Vehicle List:**
    - `Config.Stealing_Cars.VehList`: Specify the list of cars that can be stolen.
  - **Vehicle Locations:**
    - `Config.Stealing_Cars.CarLocalisations`: Define the possible spawn locations for target vehicles and their associated scanner locations.
  - **Drop-off Locations:**
    - `Config.Stealing_Cars.CarDeposit`: Define multiple drop-off points where players will deliver stolen vehicles.

For a more detailed configuration, you can check out the `config.lua` file to explore all available options.

## How It Works

1. **Receive a Mission:** Players start by interacting with an NPC to receive a random car theft mission.
2. **Use the Signal Scanner:** The provided signal scanner helps the player locate the target vehicle within a specific radius on the map.
3. **Hack the Vehicle:** Players must complete a skill-based hacking minigame to bypass the car’s security system.
4. **Steal & Deliver:** After successfully hacking the car, players must drive the stolen vehicle to the drop-off point, avoiding police or rival factions.
5. **Complete the Mission:** Interact with Pedro, the buyer NPC, to turn in the vehicle and receive payment.

## Support

If you run into any issues or have suggestions for improvements, feel free to join our discord https://discord.gg/vild or contribute to the repository with a pull request. Your feedback is appreciated!

## Our Other Media
#### **Discord**
- https://discord.gg/vild
#### **YouTube**
- https://www.youtube.com/@VildStore
#### **TikTok**
- https://www.tiktok.com/@vildstore
#### **Tebex Store**
- https://vildstore.com

---

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.
