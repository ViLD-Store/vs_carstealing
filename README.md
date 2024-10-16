![image](https://github.com/user-attachments/assets/0ca66c77-c972-46e2-a6a7-ad1f94f84d1d)
# vs_carstealing

### Bring the thrill of car theft to your FiveM server with `vs_carstealing`

Elevate the criminal underworld on your FiveM server with `vs_carstealing`. This immersive script allows players to engage in high-stakes car theft missions, where they hack vehicles, evade the police, and deliver stolen cars for rewards. It's an excellent addition for servers focused on roleplay, economy-driven experiences, or just a touch of organized crime.

## Key Features

- **Dynamic Task System:** Players are assigned randomized car theft missions, ensuring fresh and varied gameplay each time.
- **Signal Scanner Mechanic:** Players use a signal scanner to track down target vehicles within a specific radius on the map.
- **Challenging Hacking Minigame:** A skill-based mini-challenge to hack into the vehicle’s security system, adding depth to the gameplay.
- **Theft & Delivery:** Players steal vehicles and deliver them to designated drop-off locations to earn cash rewards.
- **NPC Interaction:** Players interact with Pedro, the NPC buyer, to turn in stolen vehicles and get paid.
- **Fully Configurable:** The script is highly customizable, allowing you to tweak mission settings, rewards, vehicle locations, and more to fit your server’s needs.
- **Immersive Roleplay:** Enhance your server’s criminal activities with an engaging, realistic car theft system that integrates seamlessly into any roleplay environment.

## Preview

Get a sneak peek of `vs_carstealing` in action with this [preview video](https://www.youtube.com/watch?v=2Jdj9aSof84)!

---

## Installation

Follow these steps to install `vs_carstealing`:

1. Download the `vs_carstealing` script from the repository.
2. Extract the folder into your FiveM server's `resources` directory.
3. Add `ensure vs_carstealing` to your `server.cfg` to start the resource.
4. Customize the `config.lua` file to tailor the script to your server’s preferences.
5. Restart your server and start stealing cars!

---

## Configuration

The script is designed to be as flexible as possible. You can adjust nearly every aspect of gameplay in the `config.lua` file to suit your server's needs. Below is a breakdown of the key configuration options:

### General Settings

- **Language Support:**
  - `Config.Lang`: Select the language used for in-game messages. Default is `'en'`. Customize the available messages in `Config.Language` to localize the experience.

- **Framework Integration:**
  - `Config.Bridge.Notification`: Set the notification system (supports `ESX`, `QB`, `OKOK`, `OX`, `mythic`, or custom integration).
  - `Config.Bridge.MiniGame`: Choose the hacking minigame type (`'path'`, `'spot'`, or `'math'`).

- **Police Integration:**
  - `Config.PoliceJob`: Define the police job for your server. Default is `'police'`.
  - `Config.PoliceJobs`: Set the minimum number of police officers required online before a player can start a mission.

### Timing & Cooldown

- **Mission Timers:**
  - `Config.Wait.Found`: Time (in milliseconds) that players must wait after locating the vehicle.
  - `Config.Wait.Cooldown`: Cooldown period between missions.
  - `Config.Wait.WhenPlayerCanGoSell`: Delay before players can sell the stolen car to the buyer NPC.

### Car Theft Missions

- **NPC Configuration:**
  - `Config.Stealing_Cars.Ped.Ped`: Set the model of the NPC who gives missions.
  - `Config.Stealing_Cars.Ped.Loc`: Specify the location of the mission NPC on the map.

- **Vehicle List:**
  - `Config.Stealing_Cars.VehList`: Define which vehicles players are tasked to steal (e.g., `sultan`, `adder`, etc.).

- **Target Vehicle Locations:**
  - `Config.Stealing_Cars.CarLocalisations`: Set spawn points for the target vehicles and signal scanner locations.

- **Drop-off Points:**
  - `Config.Stealing_Cars.CarDeposit`: Define the locations where players deliver stolen cars for a reward.

### Reward & Payment

- **Item Requirements:**
  - `Config.Item.UseItem`: Enable or disable the requirement for an item to initiate the mission.
  - `Config.Item.DeleteItem`: Set whether the required item is consumed upon use.

- **Payment System:**
  - `Config.Payment.type`: Specify the type of reward (e.g., `money` or custom currency).
  - `Config.Payment.min` & `Config.Payment.max`: Set the minimum and maximum payment players can receive for delivering stolen vehicles.

---

## Gameplay Overview

1. **Receive a Mission:** Players interact with an NPC (Pedro) to receive a randomized car theft mission.
2. **Use the Signal Scanner:** Players locate the target vehicle using a signal scanner, which directs them within a certain radius.
3. **Hack the Car:** Players must complete a hacking minigame to unlock the vehicle’s security system.
4. **Steal & Deliver:** Once the car is hacked, players steal the vehicle and must evade the police as they drive it to a drop-off location.
5. **Get Paid:** Players deliver the car to Pedro, the buyer NPC, and receive a reward.

---

## Support & Community

Have questions or suggestions? Join our community and get help:

- **Discord:** [Join us on Discord](https://discord.gg/vild) for support and updates.
- **YouTube:** [Watch our videos](https://www.youtube.com/@VildStore) for tutorials and showcases.
- **TikTok:** [Follow us on TikTok](https://www.tiktok.com/@vildstore) for behind-the-scenes content.
- **Tebex Store:** [Visit our Tebex Store](https://vildstore.com) for more exciting resources.

---

## License

`vs_carstealing` is licensed under the MIT License. For more details, see the [LICENSE](./LICENSE) file.
