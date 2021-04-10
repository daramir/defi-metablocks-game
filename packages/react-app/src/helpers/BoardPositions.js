import BoardMeasures, {BoardSizes} from "../constants/BoardMeasures"


const tileIdToSide = (tileId) => {
    if (tileId < 10) {
        return BoardSizes.SIDE_BOTTOM;
    } else if (tileId < 20) {
        return BoardSizes.SIDE_LEFT;
    } else if (tileId < 30) {
        return BoardSizes.SIDE_TOP;
    } else {
        return BoardSizes.SIDE_RIGHT;
    }
}

const tileIdToPos = (tileId) => {
    if (tileId < 10) {
        return [10, 10 - tileId];
    } else if (tileId < 20) {
        return [20 - tileId, 0];
    } else if (tileId < 30) {
        return [0, tileId - 20];
    } else {
        return [tileId - 30, 10];
    }
}


export function boardToWorld(options) {
    const {tileId, type, total, index} = options;
    const pos = tileIdToPos(tileId);
    let x = 0.5 + pos[1];
    let z = 0.5 + pos[0];

    const side = tileIdToSide(tileId);

    if (type === BoardMeasures.MODEL_PLAYER) {
        if (total === 1) {
            return [x * BoardMeasures.SQUARE_SIZE, 0, z * BoardMeasures.SQUARE_SIZE];
        } else {
            switch (side) {
                case BoardSizes.SIDE_TOP:
                    z -= BoardMeasures.MODEL_PLAYER_MARGIN;
                    x = (index % 2 === 0) ? x + BoardMeasures.MODEL_PLAYER_OFFSET : x - BoardMeasures.MODEL_PLAYER_OFFSET;
                    if (total > 2) z = (index < 2) ? z + BoardMeasures.MODEL_PLAYER_OFFSET : z - BoardMeasures.MODEL_PLAYER_OFFSET;
                    break;
                case BoardSizes.SIDE_BOTTOM:
                    z += BoardMeasures.MODEL_PLAYER_MARGIN;
                    x = (index % 2 === 0) ? x - BoardMeasures.MODEL_PLAYER_OFFSET : x + BoardMeasures.MODEL_PLAYER_OFFSET;
                    if (total > 2) z = (index < 2) ? z - BoardMeasures.MODEL_PLAYER_OFFSET : z + BoardMeasures.MODEL_PLAYER_OFFSET;
                    break;
                case BoardSizes.SIDE_LEFT:
                    x -= BoardMeasures.MODEL_PLAYER_MARGIN;
                    z = (index % 2 === 0) ? z - BoardMeasures.MODEL_PLAYER_OFFSET : z + BoardMeasures.MODEL_PLAYER_OFFSET;
                    if (total > 2) x = (index < 2) ? x + BoardMeasures.MODEL_PLAYER_OFFSET : x - BoardMeasures.MODEL_PLAYER_OFFSET;
                    break;
                case BoardSizes.SIDE_RIGHT:
                    x += BoardMeasures.MODEL_PLAYER_MARGIN;
                    z = (index % 2 === 0) ? z + BoardMeasures.MODEL_PLAYER_OFFSET : z - BoardMeasures.MODEL_PLAYER_OFFSET;
                    if (total > 2) x = (index < 2) ? x - BoardMeasures.MODEL_PLAYER_OFFSET : x + BoardMeasures.MODEL_PLAYER_OFFSET;
                    break;
            }
        }
    } else if (type === BoardMeasures.MODEL_PROPERTY) {
        switch (side) {
            case BoardSizes.SIDE_TOP:
                z += BoardMeasures.MODEL_PROPERTY_TOP_MARGIN;
                x += BoardMeasures.MODEL_PROPERTY_LEFT_MARGIN;
                x -= (total - 1) * BoardMeasures.MODEL_PROPERTY_MARGIN + BoardMeasures.MODEL_PROPERTY_LEFT_OFFSET * (total > 1);
                break;
            case BoardSizes.SIDE_BOTTOM:
                z -= BoardMeasures.MODEL_PROPERTY_TOP_MARGIN;
                x -= BoardMeasures.MODEL_PROPERTY_LEFT_MARGIN;
                x += (total - 1) * BoardMeasures.MODEL_PROPERTY_MARGIN + BoardMeasures.MODEL_PROPERTY_LEFT_OFFSET * (total > 1);
                break;
            case BoardSizes.SIDE_LEFT:
                x += BoardMeasures.MODEL_PROPERTY_TOP_MARGIN;
                z -= BoardMeasures.MODEL_PROPERTY_LEFT_MARGIN;
                z += (total - 1) * BoardMeasures.MODEL_PROPERTY_MARGIN + BoardMeasures.MODEL_PROPERTY_LEFT_OFFSET * (total > 1);
                break;
            case BoardSizes.SIDE_RIGHT:
                x -= BoardMeasures.MODEL_PROPERTY_TOP_MARGIN;
                z += BoardMeasures.MODEL_PROPERTY_LEFT_MARGIN;
                z -= (total - 1) * BoardMeasures.MODEL_PROPERTY_MARGIN + BoardMeasures.MODEL_PROPERTY_LEFT_OFFSET * (total > 1);
                break;
        }
    }
    return [x * BoardMeasures.SQUARE_SIZE, 0, z * BoardMeasures.SQUARE_SIZE];
}