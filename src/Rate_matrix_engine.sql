-- ============================================================================
-- Enterprise Practice : Elsamag IT Solutions
-- Author & Lead Cons. : Samuel Chinwendu Agu
-- Repository Target   : https://github.com/Elsamag/sql-travel-ratematrix-crossjoin-engine
-- File Path           : src/rate_matrix_engine.sql
-- Production Scope    : Multiplicative Combinatorial Hospitality Pricing Engine
-- Dialect Standard    : ANSI SQL (PostgreSQL 14+, MySQL 8.0+, SQLite 3+)
-- ============================================================================

-- Step 1: Combinatorial Nightly Rate Matrix Calculation
SELECT
    r.room_id,
    r.room_type,
    r.base_rate,
    s.season_name,
    s.rate_multiplier,
    p.package_name,
    p.package_fee,
    ROUND(
        (r.base_rate * s.rate_multiplier) + p.package_fee,
        2
    ) AS calculated_nightly_rate
FROM
    rooms AS r
CROSS JOIN
    seasons AS s
CROSS JOIN
    amenity_packages AS p
WHERE
    r.is_active = TRUE
    AND s.is_active = TRUE
    AND p.is_available = TRUE
ORDER BY
    r.room_id ASC,
    s.season_id ASC,
    p.package_id ASC;

-- Step 2: Aggregated Inventory Yield Projections by Season Tier
SELECT
    s.season_name,
    COUNT(*) AS total_package_combinations,
    ROUND(MIN((r.base_rate * s.rate_multiplier) + p.package_fee), 2) AS min_available_rate,
    ROUND(AVG((r.base_rate * s.rate_multiplier) + p.package_fee), 2) AS avg_seasonal_rate,
    ROUND(MAX((r.base_rate * s.rate_multiplier) + p.package_fee), 2) AS peak_available_rate
FROM
    rooms AS r
CROSS JOIN
    seasons AS s
CROSS JOIN
    amenity_packages AS p
WHERE
    r.is_active = TRUE
    AND s.is_active = TRUE
    AND p.is_available = TRUE
GROUP BY
    s.season_id,
    s.season_name
ORDER BY
    avg_seasonal_rate DESC;
