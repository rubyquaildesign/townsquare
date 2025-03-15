<template>
  <ul class="info">
    <li
      class="edition"
      :class="['edition-' + edition.id]"
      :style="{
        backgroundImage: `url(${
          edition.logo && grimoire.isImageOptIn
            ? edition.logo
            : require('../assets/editions/' + edition.id + '.png')
        })`
      }"
    ></li>
    <li v-if="players.length - teams.traveler < 5">
      Please add more players!
    </li>
    <li>
      <span class="meta" v-if="!edition.isOfficial">
        {{ edition.name }}
        {{ edition.author ? "by " + edition.author : "" }}
      </span>
      <span>
        {{ players.length }} <font-awesome-icon class="players" icon="users" />
      </span>
      <span>
        {{ teams.alive }}
        <font-awesome-icon class="alive" icon="heartbeat" />
      </span>
      <span>
        {{ teams.votes }} <font-awesome-icon class="votes" icon="vote-yea" />
      </span>
    </li>
    <li v-if="players.length - teams.traveler >= 5">
      <span>
        {{ teams.townsfolk }}
        <font-awesome-icon class="townsfolk" icon="user-friends" />
      </span>
      <span>
        {{ teams.outsider }}
        <font-awesome-icon
          class="outsider"
          :icon="teams.outsider > 1 ? 'user-friends' : 'user'"
        />
      </span>
      <span>
        {{ teams.minion }}
        <font-awesome-icon
          class="minion"
          :icon="teams.minion > 1 ? 'user-friends' : 'user'"
        />
      </span>
      <span>
        {{ teams.demon }}
        <font-awesome-icon
          class="demon"
          :icon="teams.demon > 1 ? 'user-friends' : 'user'"
        />
      </span>
      <span v-if="teams.traveler">
        {{ teams.traveler }}
        <font-awesome-icon
          class="traveler"
          :icon="teams.traveler > 1 ? 'user-friends' : 'user'"
        />
      </span>
      <span v-if="grimoire.isNight">
        Night phase
        <font-awesome-icon :icon="['fas', 'cloud-moon']" />
      </span>
    </li>
  </ul>
</template>

<script>
import gameJSON from "./../game";
import { mapState } from "vuex";

export default {
  computed: {
    teams: function() {
      const { players } = this.$store.state.players;
      const nonTravelers = this.$store.getters["players/nonTravelers"];
      const alive = players.filter(player => player.isDead !== true).length;
      return {
        ...gameJSON[nonTravelers - 5],
        traveler: players.length - nonTravelers,
        alive,
        votes:
          alive +
          players.filter(
            player => player.isDead === true && player.isVoteless !== true
          ).length
      };
    },
    ...mapState(["edition", "grimoire"]),
    ...mapState("players", ["players"])
  }
};
</script>

<style lang="scss" scoped>
@import "../vars.scss";

.info {
  position: absolute;
  display: flex;
  width: 20%;
  height: 20%;
  padding:70px 0 0;
  align-items: center;
  align-content: center;
  justify-content: center;
  flex-wrap: wrap;
  background-size: auto 100%;

  li {
    font-weight: bold;
    width: 100%;
    display: flex;
    flex-wrap: wrap;
    justify-content: center;

    span {
      white-space: nowrap;
    }

    .meta {
      text-align: center;
      flex-basis: 100%;
      font-family: sans-serif;
      font-weight: normal;
    }

    svg {
      margin-right: 10px;
    }

    .players {
      color: $traveler;
    }
    .alive {
      color: $traveler;
    }
    .votes {
      color: #000000;
    }
    .townsfolk {
      color: $townsfolk;
    }
    .outsider {
      color: $outsider;
    }
    .minion {
      color: $minion;
    }
    .demon {
      color: $demon;
    }
    .traveler {
      color: $traveler;
    }
  }

  li.edition {
    width: 170px;
    height: 200px;
    max-width: 100%;
    max-height: 100%;
    background-position: 0 center;
    background-repeat: no-repeat;
    background-size: 100% auto;
    position: absolute;
    top: -25%;
    opacity: 0.4;
  }
}
</style>
