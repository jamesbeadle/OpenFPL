# OpenFPL Design Patterns

This document details the design patterns utilised in the development of the OpenFPL fantasy football application on the Internet Computer blockchain. These patterns are selected to ensure the application is scalable, maintainable & focused on efficient data management.

## Snapshot Manager: Memento Pattern

- **Purpose**: To capture and store the state of fantasy football teams at specific times, in line with the season's progression.
- **Integration**: Incorporated within the Season Manager to streamline snapshot creation each gameweek.
- **Reasoning**: Enhances cohesion and simplifies the process, ensuring that snapshots are directly linked to and triggered by key moments in the season.

## Club & Player Management: Composite Pattern

- **Purpose**: To manage clubs and players in a unified manner, allowing operations to be applied uniformly.
- **Reasoning**: Simplifies the management of teams and players, especially useful for operations like point calculation and club composition adjustments.

## Season Management & Validation Rules: Strategy Pattern

- **Purpose**: To define and implement a variety of algorithms for different season-specific rules and validation strategies.
- **Reasoning**: Provides flexibility in managing varying season-specific rules and team validation criteria, enhancing the adaptability of the application.

## Real-Time Season Updates: Observer Pattern 

- **Purpose**: Specifically designed to manage and propagate real-time updates throughout the application in response to season-related events..
- **Reasoning**: This pattern is employed to notify and update various components such as leaderboards and fantasy team interfaces when a season-related event occurs.

## Observer Pattern for Real-Time Governance Updates

- **Purpose**: To manage and disseminate updates across the application in response to external governance decisions.
- **Reasoning**: This integration is crucial for ensuring that the application reflects governance-driven changes accurately and promptly across all relevant components, such as player statistics, club and fantasy team, thereby maintaining data consistency and a seamless user experience.


## Factory Method Pattern within Season Management for Snapshot Creation

- **Purpose**: To encapsulate the complexity of creating snapshots of team states within the Season Manager.
- **Reasoning**: By integrating it into the Season Manager, this pattern helps abstract the snapshot creation process, naturally fitting within the season's flow.

## Singleton Pattern for Main Canister Management

- **Purpose**: To act as the central coordinator and the primary interface for the application, especially for managing timers and events, triggering actions across components like the Season Manager.
- **Reasoning**: Enables the Singleton to effectively manage and coordinate the apps scheduled events and interactions.


## Summary


OpenFPL fantasy football application has carefully chosen design patterns to enhance the scalability and maintainability of the system.






