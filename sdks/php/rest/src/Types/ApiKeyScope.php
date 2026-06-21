<?php

namespace Brume\Rest\Types;

enum ApiKeyScope: string
{
    case Publish = "publish";
    case ReadStats = "read_stats";
    case ManageKeys = "manage_keys";
    case ManageProject = "manage_project";
}
