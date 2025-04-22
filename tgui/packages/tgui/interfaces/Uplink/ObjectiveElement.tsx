import { Box, Button, Flex } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { useBackend } from '../../backend';
export type Objective = {
  id: number;
  name: string;
  description: string;
};

type ObjectiveElementProps = {
  name: string;
  description: string;
  reference: string;
  rerollable: number;
  prime: number;
};

export const ObjectiveElement = (props: ObjectiveElementProps) => {
  const { name, description, reference, rerollable, prime } = props;
  const { act } = useBackend();

  return (
    <Flex direction="column">
      <Flex.Item grow={false} basis="content">
        <Box
          className={classes([
            'UplinkObjective__Titlebar',
            `reputation-${prime !== 0 ? 'prime' : 'very-good'}`,
          ])}
          width="100%"
        >
          <Box className="UplinkObjective__Titlebar__Content">
            <Box className="UplinkObjective__Titlebar__Title">{name}</Box>
            {(rerollable === 1 || prime === 1) && (
              <Button
                className="UplinkObjective__Titlebar__RerollButton"
                color=" "
                onClick={() => act('reroll_objective', { ref: reference })}
              >
                Prime
              </Button>
            )}
          </Box>
        </Box>
      </Flex.Item>
      <Flex.Item grow={false} basis="content">
        <Box className="UplinkObjective__Content" height="100%">
          <Box>{description}</Box>
        </Box>
      </Flex.Item>
    </Flex>
  );
};
