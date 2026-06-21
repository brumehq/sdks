<?php

namespace Brume\Rest\Types;

enum Tier: string
{
    case Free = "free";
    case Starter = "starter";
    case Pro = "pro";
    case Business = "business";
}
