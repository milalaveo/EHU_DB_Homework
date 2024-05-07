CREATE SCHEMA climbing_info;

-- Skills Table
CREATE TABLE climbing_info.Skills (
    SkillID SERIAL PRIMARY KEY,
    SkillName VARCHAR(255) NOT NULL,
    Description varchar(255)
);

-- Climbers Table
CREATE TABLE climbing_info.Climbers (
    ClimberID SERIAL PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Address VARCHAR(255),
    DateOfBirth DATE CHECK (DateOfBirth > '2000-01-01')
);

-- Accommodations Table
CREATE TABLE climbing_info.Accommodations (
    AccommodationID SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Address VARCHAR(255),
    Type VARCHAR(255) NOT NULL
);

-- Guides Table
CREATE TABLE climbing_info.Guides (
    GuideID SERIAL PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Qualifications VARCHAR(255)
);

-- Mountains Table
CREATE TABLE climbing_info.Mountains (
    MountainID SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Height INT CHECK (Height > 0),
    Country VARCHAR(255) NOT NULL,
    Region VARCHAR(255) NOT NULL
);

-- Climbs Table
CREATE TABLE climbing_info.Climbs (
    ClimbID SERIAL PRIMARY KEY,
    MountainID INT NOT NULL REFERENCES climbing_info.Mountains(MountainID),
    ClimbStartDate DATE NOT NULL,
    ClimbEndDate DATE NOT NULL
);

-- ClimbParticipants Table
CREATE TABLE climbing_info.ClimbParticipants (
    ClimbID INT NOT NULL,
    ClimberID INT NOT NULL,
    Role VARCHAR(255) CHECK (Role IN ('Leader', 'Support')),
    PRIMARY KEY (ClimbID, ClimberID),
    FOREIGN KEY (ClimbID) REFERENCES climbing_info.Climbs(ClimbID),
    FOREIGN KEY (ClimberID) REFERENCES climbing_info.Climbers(ClimberID)
);

-- WeatherConditions Table
CREATE TABLE climbing_info.WeatherConditions (
    WeatherID SERIAL PRIMARY KEY,
    Description VARCHAR(255)
);

-- ClimbWeather Table
CREATE TABLE climbing_info.ClimbWeather (
    ClimbID INT NOT NULL,
    WeatherID INT NOT NULL,
    RecordedTime TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, --- ???
    PRIMARY KEY (ClimbID, WeatherID),
    FOREIGN KEY (ClimbID) REFERENCES climbing_info.Climbs(ClimbID),
    FOREIGN KEY (WeatherID) REFERENCES climbing_info.WeatherConditions(WeatherID)
);

-- Routes Table
CREATE TABLE climbing_info.Routes (
    RouteID SERIAL PRIMARY KEY,
    MountainID INT NOT NULL REFERENCES climbing_info.Mountains(MountainID),
    RouteName VARCHAR(255) NOT NULL,
    Description VARCHAR(255)
);

-- Gear Table
CREATE TABLE climbing_info.Gear (
    GearID SERIAL PRIMARY KEY,
    GearName VARCHAR(255) NOT NULL,
    GearType VARCHAR(255) NOT NULL
);

-- ClimbGear Table
CREATE TABLE climbing_info.ClimbGear (
    ClimbID INT NOT NULL,
    GearID INT NOT NULL,
    Quantity INT CHECK (Quantity > 0),
    PRIMARY KEY (ClimbID, GearID),
    FOREIGN KEY (ClimbID) REFERENCES climbing_info.Climbs(ClimbID),
    FOREIGN KEY (GearID) REFERENCES climbing_info.Gear(GearID)
);

-- Inserting into Skills
INSERT INTO climbing_info.Skills (SkillName, Description) VALUES
('Basic Climbing', 'Fundamental techniques and safety procedures'),
('Advanced Climbing', 'Advanced techniques for complex ascents');

-- Inserting into Climbers
INSERT INTO climbing_info.Climbers (FirstName, LastName, Address, DateOfBirth) VALUES
('Ella', 'Greenwood', '123 Cliff Ave', '2005-03-15'),
('Lucas', 'Boulder', '234 Ridge Rd', '2002-08-22');

-- Inserting into Accommodations
INSERT INTO climbing_info.Accommodations (Name, Address, Type) VALUES
('Basecamp Lodge', '1010 High Trail', 'Lodge'),
('Summit Stay', '2020 Peak Pkwy', 'Cabin');

-- Inserting into Guides
INSERT INTO climbing_info.Guides (FirstName, LastName, Qualifications) VALUES
('Mia', 'Sharp', 'Certified Alpine Guide'),
('Noah', 'Crag', 'High Altitude Specialist');

-- Inserting into Mountains
INSERT INTO climbing_info.Mountains (Name, Height, Country, Region) VALUES
('El Capitan', 2307, 'USA', 'California'),
('Mont Blanc', 4810, 'France/Italy', 'The Alps');

-- Inserting into Climbs
INSERT INTO climbing_info.Climbs (MountainID, ClimbStartDate, ClimbEndDate) VALUES
((SELECT MountainID FROM climbing_info.Mountains WHERE Name = 'El Capitan'), '2024-06-01', '2024-06-05'),
((SELECT MountainID FROM climbing_info.Mountains WHERE Name = 'Mont Blanc'), '2024-07-20', '2024-07-25');

-- Inserting into ClimbParticipants
INSERT INTO climbing_info.ClimbParticipants (ClimbID, ClimberID, Role) VALUES
((SELECT ClimbID FROM climbing_info.Climbs WHERE MountainID = (SELECT MountainID FROM climbing_info.Mountains WHERE Name = 'El Capitan')), (SELECT ClimberID FROM climbing_info.Climbers WHERE FirstName = 'Ella'), 'Leader'),
((SELECT ClimbID FROM climbing_info.Climbs WHERE MountainID = (SELECT MountainID FROM climbing_info.Mountains WHERE Name = 'Mont Blanc')), (SELECT ClimberID FROM climbing_info.Climbers WHERE FirstName = 'Lucas'), 'Support');

-- Inserting into WeatherConditions
INSERT INTO climbing_info.WeatherConditions (Description) VALUES
('Clear skies'),
('Snowstorm');

-- Inserting into ClimbWeather
INSERT INTO climbing_info.ClimbWeather (ClimbID, WeatherID) VALUES
((SELECT ClimbID FROM climbing_info.Climbs WHERE MountainID = (SELECT MountainID FROM climbing_info.Mountains WHERE Name = 'El Capitan')), (SELECT WeatherID FROM climbing_info.WeatherConditions WHERE Description = 'Clear skies')),
((SELECT ClimbID FROM climbing_info.Climbs WHERE MountainID = (SELECT MountainID FROM climbing_info.Mountains WHERE Name = 'Mont Blanc')), (SELECT WeatherID FROM climbing_info.WeatherConditions WHERE Description = 'Snowstorm'));

-- Inserting into Routes
INSERT INTO climbing_info.Routes (MountainID, RouteName, Description) VALUES
((SELECT MountainID FROM climbing_info.Mountains WHERE Name = 'El Capitan'), 'The Nose', 'Classic big-wall route with immense exposure'),
((SELECT MountainID FROM climbing_info.Mountains WHERE Name = 'Mont Blanc'), 'The Gouter Route', 'The most popular route to the summit');

-- Inserting into Gear
INSERT INTO climbing_info.Gear (GearName, GearType) VALUES
('Climbing Rope', 'Equipment'),
('Carabiner', 'Accessory');

-- Inserting into ClimbGear
INSERT INTO climbing_info.ClimbGear (ClimbID, GearID, Quantity) VALUES
((SELECT ClimbID FROM climbing_info.Climbs WHERE MountainID = (SELECT MountainID FROM climbing_info.Mountains WHERE Name = 'El Capitan')), (SELECT GearID FROM climbing_info.Gear WHERE GearName = 'Climbing Rope'), 5),
((SELECT ClimbID FROM climbing_info.Climbs WHERE MountainID = (SELECT MountainID FROM climbing_info.Mountains WHERE Name = 'Mont Blanc')), (SELECT GearID FROM climbing_info.Gear WHERE GearName = 'Carabiner'), 20);


-- Adding the record timestamp to each table
ALTER TABLE climbing_info.Skills ADD COLUMN record_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE climbing_info.Climbers ADD COLUMN record_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE climbing_info.Accommodations ADD COLUMN record_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE climbing_info.Guides ADD COLUMN record_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE climbing_info.Mountains ADD COLUMN record_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE climbing_info.Climbs ADD COLUMN record_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE climbing_info.ClimbParticipants ADD COLUMN record_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE climbing_info.WeatherConditions ADD COLUMN record_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE climbing_info.Routes ADD COLUMN record_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE climbing_info.Gear ADD COLUMN record_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE climbing_info.ClimbGear ADD COLUMN record_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP;