select
    creative_id,
    creative_type,
    lower(trim(concept_theme)) as concept_theme -- Уніфікація тексту
from {{ source('marketing_source', 'creative_metadata') }}