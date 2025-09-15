-- Users table contains all credentials information about the user
CREATE TABLE users (
    user_id UUID PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Users profile table required for storing user's profile information
CREATE TABLE user_profiles (
    profile_id UUID PRIMARY KEY,
    user_id UUID UNIQUE REFERENCES users(user_id),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    bio TEXT, -- can contains everything about user(schooling, experience, job, interests, hobbies)
    profile_picture_url VARCHAR(255),
    gender VARCHAR(20),
    date_of_birth DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Cities table stores the values of the all the cities(Hometown/current_city)
CREATE TABLE cities (
    city_id UUID PRIMARY KEY,
    city_name VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    country VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20)
);

-- Stores users with associated hometowns
CREATE TABLE user_hometown (
    user_id UUID PRIMARY KEY REFERENCES users(user_id),
    hometown_id UUID REFERENCES cities(city_id)
);

-- Stores users with associated current city
CREATE TABLE user_current_city (
    user_id UUID PRIMARY KEY REFERENCES users(user_id),
    city_id UUID REFERENCES cities(city_id),
    since_date DATE
);

-- Stores the connection request data
CREATE TABLE connections (
    connection_id UUID PRIMARY KEY,
    user_id_1 UUID REFERENCES users(user_id),
    user_id_2 UUID REFERENCES users(user_id),
    status VARCHAR(20) NOT NULL, -- pending/accepted/blocked
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_connection UNIQUE (user_id_1, user_id_2),
    CHECK (user_id_1 < user_id_2) -- Ensures unique pairs
);


-- Schema for the chats and messages (used for storing in NoSQL and Kafka)
/*
{
  message_id: UUID,
  chat_id: UUID,
  sender_id: UUID,
  receiver_id: UUID, // null in case of the group message
  // get the receipient list from the participant list
  message_text: String,
  media_url: String,
  message_type: String, // text/image/video/file
  timestamp: DateTime,
  status: String, // sent/delivered/read
  is_deleted: Boolean,
  deleted_at: DateTime
}

{
  chat_id: UUID,
  participant_ids: [UUID],
  chat_type: String, // individual/group
  last_message_id: UUID,
  last_message_preview: String,
  created_at: DateTime,
  updated_at: DateTime,
  is_active: Boolean
}
*/

/*
Entity Relationships
User → UserProfile: One-to-One
User → Hometown: One-to-One (through user_hometown)
User → CurrentCity: One-to-One (through user_current_city)
User → Connections: Many-to-Many (self-referential)
User → Messages: One-to-Many
User → Chats: Many-to-Many (through participant_ids)
*/

-- For better search qurying we can use following indexes
-- User related indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_phone ON users(phone_number);
CREATE INDEX idx_user_profiles_user_id ON user_profiles(user_id);
CREATE INDEX idx_connections_users ON connections(user_id_1, user_id_2);