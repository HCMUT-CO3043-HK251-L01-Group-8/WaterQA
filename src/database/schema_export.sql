BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "AI_PREDICTION" (
	"prediction_id"	INTEGER,
	"observation_id"	INTEGER NOT NULL UNIQUE,
	"predicted_at"	DATETIME NOT NULL,
	"result"	TEXT NOT NULL,
	"confidence"	REAL,
	"model_name"	TEXT,
	"risk_level"	TEXT,
	"recommendation"	TEXT,
	PRIMARY KEY("prediction_id" AUTOINCREMENT),
	FOREIGN KEY("observation_id") REFERENCES "OBSERVATION"("observation_id")
);
CREATE TABLE IF NOT EXISTS "ALERT" (
	"alert_id"	INTEGER,
	"observation_id"	INTEGER,
	"station_id"	INTEGER NOT NULL,
	"event_type"	TEXT NOT NULL,
	"severity"	TEXT NOT NULL CHECK("severity" IN ('low', 'medium', 'high', 'critical')),
	"description"	TEXT,
	"status"	TEXT NOT NULL,
	"created_at"	DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"resolved_at"	DATETIME,
	PRIMARY KEY("alert_id" AUTOINCREMENT),
	FOREIGN KEY("observation_id") REFERENCES "OBSERVATION"("observation_id"),
	FOREIGN KEY("station_id") REFERENCES "IOT_STATION"("station_id")
);
CREATE TABLE IF NOT EXISTS "ALERT_THRESHOLD" (
	"threshold_id"	INTEGER,
	"station_id"	INTEGER,
	"parameter_name"	TEXT NOT NULL,
	"lower_threshold"	REAL NOT NULL,
	"upper_threshold"	REAL NOT NULL,
	"severity_level"	TEXT NOT NULL,
	"updated_at"	DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"set_by_user_id"	INTEGER NOT NULL,
	PRIMARY KEY("threshold_id" AUTOINCREMENT),
	FOREIGN KEY("set_by_user_id") REFERENCES "USER"("user_id"),
	FOREIGN KEY("station_id") REFERENCES "IOT_STATION"("station_id"),
	CHECK("lower_threshold" <= "upper_threshold")
);
CREATE TABLE IF NOT EXISTS "IOT_STATION" (
	"station_id"	INTEGER,
	"station_name"	TEXT NOT NULL,
	"location"	TEXT,
	"status"	TEXT NOT NULL,
	"installed_at"	DATETIME NOT NULL,
	"last_heartbeat"	DATETIME,
	"description"	TEXT,
	PRIMARY KEY("station_id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "NOTIFICATION" (
	"notification_id"	INTEGER,
	"alert_id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"channel"	TEXT NOT NULL,
	"sent_at"	DATETIME,
	"send_status"	TEXT NOT NULL,
	"retry_count"	INTEGER DEFAULT 0 CHECK("retry_count" >= 0),
	PRIMARY KEY("notification_id" AUTOINCREMENT),
	FOREIGN KEY("alert_id") REFERENCES "ALERT"("alert_id"),
	FOREIGN KEY("user_id") REFERENCES "USER"("user_id")
);
CREATE TABLE IF NOT EXISTS "OBSERVATION" (
	"observation_id"	INTEGER,
	"station_id"	INTEGER NOT NULL,
	"light_intensity"	REAL,
	"water_level"	REAL,
	"temperature"	REAL,
	"humidity"	REAL,
	"tank_surface_moisture"	REAL,
	"lid_status"	INTEGER,
	"leakage_signal"	INTEGER,
	"intrusion_signal"	INTEGER,
	"timestamp"	DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("observation_id" AUTOINCREMENT),
	FOREIGN KEY("station_id") REFERENCES "IOT_STATION"("station_id")
);
CREATE TABLE IF NOT EXISTS "SENSOR" (
	"sensor_id"	INTEGER,
	"station_id"	INTEGER NOT NULL,
	"sensor_name"	TEXT NOT NULL,
	"sensor_type"	TEXT NOT NULL,
	"unit"	TEXT,
	"status"	TEXT NOT NULL,
	PRIMARY KEY("sensor_id" AUTOINCREMENT),
	FOREIGN KEY("station_id") REFERENCES "IOT_STATION"("station_id")
);
CREATE TABLE IF NOT EXISTS "USER" (
	"user_id"	INTEGER,
	"email"	TEXT NOT NULL UNIQUE,
	"phone_number"	TEXT,
	"password_hash"	TEXT NOT NULL,
	"role"	TEXT NOT NULL CHECK("role" IN ('Admin', 'User')),
	"verification_status"	INTEGER DEFAULT 0,
	"created_at"	DATETIME DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	DATETIME,
	PRIMARY KEY("user_id" AUTOINCREMENT)
);

CREATE INDEX IF NOT EXISTS "idx_alert_station" ON "ALERT" (
	"station_id"
);
CREATE INDEX IF NOT EXISTS "idx_observation_station_time" ON "OBSERVATION" (
	"station_id",
	"timestamp"
);
COMMIT;
